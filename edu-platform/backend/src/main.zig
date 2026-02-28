const std = @import("std");
const Config = @import("config/config.zig").Config;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer gpa.deinit();
    const allocator = gpa.allocator();

    const config = try Config.load(allocator);
    std.log.info("Starting education-platform on {s}:{d}", .{ config.host, config.port });

    const addr = try std.net.Address.parseIp(config.host, config.port);
    var server = try addr.listen(.{
        .reuse_address = true,
    });
    defer server.deinit();
    std.log.info("listening ...", .{});

    while (true) {
        const conn = try server.accept();
        const t = try std.Thread.spawn(.{}, handleConnection, .{ allocator, config, conn });
        t.detach();
    }
}

fn handleConnection(allocator: std.mem.Allocator, config: Config, conn: std.net.Server.Connection) !void {
    defer conn.stream.close();

    // We'll replace this stub with the real router in the next step.
    _ = config;

    var read_buf: [4096]u8 = undefined;
    var http_server = std.http.Server.init(conn, &read_buf);

    var request = http_server.receiveHead() catch |err| {
        std.log.err("receiveHead error: {}", .{err});
        return;
    };

    // Temporary: echo 501 until router exists
    request.respond("Not Implemented\n", .{
        .status = .not_implemented,
        .extra_headers = &.{
            .{ .name = "content-type", .value = "text/plain" },
        },
    }) catch |err| {
        std.log.err("respond error: {}", .{err});
    };

    _ = allocator;
}
