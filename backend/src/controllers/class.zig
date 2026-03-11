const std = @import("std");
const httpz = @import("httpz");
const Config = @import("../config/config.zig").Config;

pub fn create(config: Config, req: *httpz.Request, res: *httpz.Response) !void {
    _ = config;
    _ = req;
    try res.json(.{ .message = "class create called" }, .{});
}

pub fn list(config: Config, req: *httpz.Request, res: *httpz.Response) !void {
    _ = config;
    _ = req;
    try res.json(.{ .message = "class list called" }, .{});
}

pub fn getOne(config: Config, req: *httpz.Request, res: *httpz.Response) !void {
    _ = config;
    _ = req;
    try res.json(.{ .message = "class getOne called" }, .{});
}
