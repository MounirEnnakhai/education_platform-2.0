const std = @import("std");
const httpz = @import("httpz");
const Config = @import("../config/config.zig").Config;

pub fn enroll(config: Config, req: *httpz.Request, res: *httpz.Response) !void {
    _ = config;
    _ = req;
    try res.json(.{ .message = "enroll called" }, .{});
}

pub fn list(config: Config, req: *httpz.Request, res: *httpz.Response) !void {
    _ = config;
    _ = req;
    try res.json(.{ .message = "enrollment list called" }, .{});
}
