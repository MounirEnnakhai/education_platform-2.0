const std = @import("std");

pub const Config = struct {
    host: []const u8,
    port: u16,
    db_path: []const u8,
    jwt_secret: []const u8,
    jwt_expiry_seconds: u64,
    bcrypt_cost: u6,
    allowed_origins: []const u8,

    pub fn load(allocator: std.mem.Allocator) !Config {
        return Config{
            .host = try envOrDefault(allocator, "HOST", "127.0.0.1"),
            .port = try envU16OrDefault("PORT", 8080),
            .db_path = try envOrDefault(allocator, "DB_PATH", "./edu_platform.db"),
            .jwt_secret = try envRequired("JWT_SECRET"),
            .jwt_expiry_seconds = try envU64OrDefault("JWT_EXPIRY_SECONDS", 86400),
            .bcrypt_cost = @intCast(try envU64OrDefault("BCRYPT_COST", 12)),
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

fn envRequired(key: []const u8) ![]const u8 {
    return std.posix.getenv(key) orelse {
        std.log.err("Required env var '{s}' is not set", .{key});
        return error.MissingEnvVar;
    };
}

fn envU16OrDefault(key: []const u8, default: u16) !u16 {
    const val = std.posix.getenv(key) orelse return default;
    return std.fmt.parseInt(u16, val, 10) catch default;
}

fn envU64OrDefault(key: []const u8, default: u64) !u64 {
    const val = std.posix.getenv(key) orelse return default;
    return std.fmt.parseInt(u64, val, 10) catch default;
}
