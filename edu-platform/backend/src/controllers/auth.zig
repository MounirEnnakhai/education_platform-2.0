// src/controllers/auth.zig
const std = @import("std");
const Config = @import("../config/config.zig").Config;
const PathParams = @import("../routes/router.zig").PathParams;

pub fn register(
    allocator: std.mem.Allocator,
    config: Config,
    request: *std.http.Server.Request,
    path_params: PathParams,
) void {
    _ = allocator;
    _ = config;
    _ = path_params;

    request.respond(
        \\{"message": "register called"}
    , .{
        .status = .ok,
        .extra_headers = &.{
            .{ .name = "content-type", .value = "application/json" },
        },
    }) catch {};
}

pub fn login(
    allocator: std.mem.Allocator,
    config: Config,
    request: *std.http.Server.Request,
    path_params: PathParams,
) void {
    _ = allocator;
    _ = config;
    _ = path_params;

    request.respond(
        \\{"message": "login called"}
    , .{
        .status = .ok,
        .extra_headers = &.{
            .{ .name = "content-type", .value = "application/json" },
        },
    }) catch {};
}
