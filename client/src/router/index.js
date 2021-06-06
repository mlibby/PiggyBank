import Vue from "vue";
import VueRouter from "vue-router";
import Home from "@/views/Home.vue";
import Amortization from "@/views/Tools/Amortization.vue";
import accountRoutes from "@/router/accounts.js";
import authRoutes from "@/router/auth.js";

Vue.use(VueRouter);

const routes = [
    {
        path: "/",
        component: Home,
    },
    {
        path: "/tools/amortization",
        component: Amortization,
    },
];

routes.push(...accountRoutes);
routes.push(...authRoutes);

const router = new VueRouter({
    mode: "history",
    base: process.env.BASE_URL,
    routes,
});

router.afterEach((to, from) => {
    document.activeElement.blur();
});

export default router;
