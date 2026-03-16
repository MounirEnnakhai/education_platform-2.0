const std = @import("std");
const pg = @import("pg");
const Config = @import("../config/config.zig").Config;

const migrations = [_][]const u8{
    @embedFile("migrations/001_create_users.sql"),
    @embedFile("migrations/002_create_classes.sql"),
    @embedFile("migrations/003_create_enrollments.sql"),
    @embedFile("migrations/004_create_schedules.sql"),
};

const migration_names = [_][]const u8{
    "001_create_users",
    "002_create_classes",
    "003_create_enrollments",
    "004_create_schedules",
};

pub const Database = struct {
    pool: *pg.Pool,

    pub fn init(allocator: std.mem.Allocator, config: Config) !Database {
        const pool = try pg.Pool.init(allocator, .{
            .size = 5,
            .connect = .{
                .host = config.db_host,
                .port = config.db_port,
            },
            .auth = .{
                .username = config.db_user,
                .password = config.db_password,
                .database = config.db_name,
            },
        });

        const db = Database{ .pool = pool };
        try db.runMigrations();

        std.log.info("Database connected and migrations applied", .{});
        return db;
    }

    pub fn deinit(self: *Database) void {
        self.pool.deinit();
    }

    fn runMigrations(self: Database) !void {
        _ = try self.pool.exec(
            \\CREATE TABLE IF NOT EXISTS schema_migrations (
            \\    id         SERIAL PRIMARY KEY,
            \\    name       VARCHAR(255) NOT NULL UNIQUE,
            \\    applied_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
            \\)
        , .{});

        inline for (migrations, migration_names) |sql, name| {
            const row = try self.pool.rowOpts(
                "SELECT id FROM schema_migrations WHERE name = $1",
                .{name},
                .{},
            );

            if (row) |r| {
                var mutable_row = r;
                mutable_row.deinit() catch {};
                std.log.info("Migration already applied: {s}", .{name});
            } else {
                _ = try self.pool.exec(sql, .{});
                _ = try self.pool.exec(
                    "INSERT INTO schema_migrations (name) VALUES ($1)",
                    .{name},
                );
                std.log.info("Migration applied: {s}", .{name});
            }
        }
    }

    pub fn acquire(self: Database) !*pg.Conn {
        return self.pool.acquire();
    }

    pub fn release(self: Database, conn: *pg.Conn) void {
        self.pool.release(conn);
    }
};
