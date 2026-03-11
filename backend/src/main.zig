const std = @import("std");
const httpz = @import("httpz");
const Config = @import("config/config.zig").Config;
const router_setup = @import("routes/router.zig").setup;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const config = try Config.load(allocator);
    std.log.info("Starting edu-platform on {s}:{d}", .{ config.host, config.port });

    var server = try httpz.Server(Config).init(
        allocator,
        .{ .port = config.port },
        config,
    );
    defer server.deinit();

    var router = server.router(.{});
    router_setup(&router);

    std.log.info("Listening on port {d}", .{config.port});
    try server.listen();
}
