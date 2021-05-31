import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";
import accountRoutes from "./accounts.js";
import Amortization from "../views/Tools/Amortization.vue";

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

const router = new VueRouter({
    mode: "history",
    base: process.env.BASE_URL,
    routes,
});

router.afterEach((to, from) => {
    document.activeElement.blur();
});

export default router;
