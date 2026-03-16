const std = @import("std");
const httpz = @import("httpz");
const Config = @import("config/config.zig").Config;
const Database = @import("database/db.zig").Database;
const router_setup = @import("routes/router.zig").setup;

pub const App = struct {
    config: Config,
    db: Database,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const config = try Config.load(allocator);
    std.log.info("Starting edu-platform on {s}:{d}", .{ config.host, config.port });

    var db = try Database.init(allocator, config);
    defer db.deinit();

    var app = App{ .config = config, .db = db };

    var server = try httpz.Server(*App).init(
        allocator,
        .{ .address = httpz.Config.AddressConfig.all(config.port) },
        &app,
    );
    defer server.deinit();

    const router = try server.router(.{});
    router_setup(router);

    std.log.info("Listening on port {d}", .{config.port});
    try server.listen();
}
