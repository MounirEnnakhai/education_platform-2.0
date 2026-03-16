// src/controllers/schedule.zig
const httpz = @import("httpz");
const App = @import("../main.zig").App;

pub fn create(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "schedule create called" }, .{});
}

pub fn list(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "schedule list called" }, .{});
}
