import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";
import SignIn from "@/views/SignIn.vue";
import Amortization from "../views/Tools/Amortization.vue";
import accountRoutes from "./accounts.js";

Vue.use(VueRouter);

const routes = [
    {
        path: "/",
        component: Home,
    },
    {
        path: "/sign-in",
        component: SignIn,
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
