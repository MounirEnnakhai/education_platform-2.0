const std = @import("std");
const httpz = @import("httpz");
const Config = @import("../config/config.zig").Config;

pub fn register(config: Config, req: *httpz.Request, res: *httpz.Response) !void {
    _ = config;
    _ = req;
    try res.json(.{ .message = "register called" }, .{});
}

pub fn login(config: Config, req: *httpz.Request, res: *httpz.Response) !void {
    _ = config;
    _ = req;
    try res.json(.{ .message = "login called" }, .{});
}
