const std = @import("std");
const Config = @import("../config/config.zig").Config;

pub const HandlerFn = *const fn (
    allocator: std.mem.Allocator,
    config: Config,
    request: *std.http.Server.Request,
    path_params: PathParams,
) void;

const PathParams = struct {
    pairs: [8]Pair = undefined,
    len: usize = 0,

    pub const Pair = struct { key: []const u8, value: []const u8 };

    pub fn get(self: PathParams, key: []const u8) ?[]const u8 {
        for (self.pairs[0..self.len]) |p| {
            if (std.mem.eql(u8, p.key, key)) return p.value;
        }
        return null;
    }
};

const Route = struct {
    method: std.http.Method,
    pattern: []const u8,
    handler: HandlerFn,
};

const auth_ctrl = @import("../controllers/auth.zig");
const class_ctrl = @import("../controllers/class.zig");
const enrollment_ctrl = @import("../controllers/enrollment.zig");
const schedule_ctrl = @import("../controllers/schedule.zig");

const routes = [_]Route{
    // Auth
    .{ .method = .POST, .pattern = "/auth/register", .handler = auth_ctrl.register },
    .{ .method = .POST, .pattern = "/auth/login", .handler = auth_ctrl.login },

    // Classes
    .{ .method = .POST, .pattern = "/classes", .handler = class_ctrl.create },
    .{ .method = .GET, .pattern = "/classes", .handler = class_ctrl.list },
    .{ .method = .GET, .pattern = "/classes/:id", .handler = class_ctrl.getOne },

    // Enrollments
    .{ .method = .POST, .pattern = "/classes/:id/enroll", .handler = enrollment_ctrl.enroll },
    .{ .method = .GET, .pattern = "/classes/:id/enrollments", .handler = enrollment_ctrl.list },

    // Schedules
    .{ .method = .POST, .pattern = "/classes/:id/schedules", .handler = schedule_ctrl.create },
    .{ .method = .GET, .pattern = "/classes/:id/schedules", .handler = schedule_ctrl.list },
};
