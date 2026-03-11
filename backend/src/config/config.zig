const std = @import("std");

pub const Config = struct {
    host: []const u8,
    port: u16,
    db_host: []const u8,
    db_port: u16,
    db_name: []const u8,
    db_user: []const u8,
    db_password: []const u8,
    jwt_secret: []const u8,
    jwt_expiry_seconds: u64,
    bcrypt_cost: u6,
    allowed_origins: []const u8,

    pub fn load(allocator: std.mem.Allocator) !Config {
        return Config{
            .host = try envOrDefault(allocator, "HOST", "0.0.0.0"),
            .port = try envU16OrDefault(allocator, "PORT", 8080),
            .db_host = try envOrDefault(allocator, "DB_HOST", "localhost"),
            .db_port = try envU16OrDefault(allocator, "DB_PORT", 5432),
            .db_name = try envOrDefault(allocator, "DB_NAME", "edu_platform"),
            .db_user = try envOrDefault(allocator, "DB_USER", "edu_user"),
            .db_password = try envRequired(allocator, "DB_PASSWORD"),
            .jwt_secret = try envRequired(allocator, "JWT_SECRET"),
            .jwt_expiry_seconds = try envU64OrDefault(allocator, "JWT_EXPIRY_SECONDS", 86400),
            .bcrypt_cost = @intCast(try envU64OrDefault(allocator, "BCRYPT_COST", 12)),
            .allowed_origins = try envOrDefault(allocator, "ALLOWED_ORIGINS", "http://localhost:5173"),
        };
    }
};

fn envOrDefault(allocator: std.mem.Allocator, key: []const u8, default: []const u8) ![]const u8 {
    return std.process.getEnvVarOwned(allocator, key) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => default,
        else => return err,
    };
}

fn envRequired(allocator: std.mem.Allocator, key: []const u8) ![]const u8 {
    return std.process.getEnvVarOwned(allocator, key) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => {
            std.log.err("Required env var '{s}' is not set", .{key});
            return error.MissingEnvVar;
        },
        else => return err,
    };
}

fn envU16OrDefault(allocator: std.mem.Allocator, key: []const u8, default: u16) !u16 {
    const val = std.process.getEnvVarOwned(allocator, key) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => return default,
        else => return err,
    };
    defer allocator.free(val);
    return std.fmt.parseInt(u16, val, 10) catch default;
}

fn envU64OrDefault(allocator: std.mem.Allocator, key: []const u8, default: u64) !u64 {
    const val = std.process.getEnvVarOwned(allocator, key) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => return default,
        else => return err,
    };
    defer allocator.free(val);
    return std.fmt.parseInt(u64, val, 10) catch default;
}
