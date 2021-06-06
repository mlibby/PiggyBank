import axios from "axios";
import router from "@/router";

const $axios = axios.create();
$axios.interceptors.response.use(
    function (response) {
        return response;
    },
    function (error) {
        if (error.response.status === 401) {
            const currentPath = window.location.pathname;
            const signInPath = "/sign-in?then=" + currentPath;
            router.push(signInPath);
        } else {
            return Promise.reject(error);
        }
    }
);

export default $axios;
