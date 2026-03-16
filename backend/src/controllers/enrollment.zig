// src/controllers/enrollment.zig
const httpz = @import("httpz");
const App = @import("../main.zig").App;

pub fn enroll(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "enroll called" }, .{});
}

pub fn list(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    _ = app;
    _ = req;
    try res.json(.{ .message = "enrollment list called" }, .{});
}
