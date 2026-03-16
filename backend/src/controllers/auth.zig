// src/controllers/auth.zig
const httpz = @import("httpz");
const App = @import("../main.zig").App;

pub fn register(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "register called" }, .{});
}

pub fn login(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "login called" }, .{});
}
