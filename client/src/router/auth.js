import SignIn from "@/views/Auth/SignIn.vue";
import SignOut from "@/views/Auth/SignOut.vue";

const authRoutes = [
    {
        name: "SignIn",
        path: "/sign-in",
        component: SignIn,
    },
    {
        name: "SignOut",
        path: "/sign-out",
        component: SignOut,
    },
];

export default authRoutes;
