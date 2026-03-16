// src/controllers/class.zig
const httpz = @import("httpz");
const App = @import("../main.zig").App;

pub fn create(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "class create called" }, .{});
}

pub fn list(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "class list called" }, .{});
}

pub fn getOne(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "class getOne called" }, .{});
}
