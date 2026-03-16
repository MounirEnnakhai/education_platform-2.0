const httpz = @import("httpz");
const App = @import("../main.zig").App;

const auth_ctrl = @import("../controllers/auth.zig");
const class_ctrl = @import("../controllers/class.zig");
const enrollment_ctrl = @import("../controllers/enrollment.zig");
const schedule_ctrl = @import("../controllers/schedule.zig");

pub fn setup(router: *httpz.Router(*App, httpz.Action(*App))) void {
    router.post("/auth/register", auth_ctrl.register, .{});
    router.post("/auth/login", auth_ctrl.login, .{});

    router.post("/classes", class_ctrl.create, .{});
    router.get("/classes", class_ctrl.list, .{});
    router.get("/classes/:id", class_ctrl.getOne, .{});

    router.post("/classes/:id/enroll", enrollment_ctrl.enroll, .{});
    router.get("/classes/:id/enrollments", enrollment_ctrl.list, .{});

    router.post("/classes/:id/schedules", schedule_ctrl.create, .{});
    router.get("/classes/:id/schedules", schedule_ctrl.list, .{});
}
