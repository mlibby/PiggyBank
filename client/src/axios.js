import axios from "axios";
import router from "@/router";

const $axios = axios.create();
$axios.interceptors.response.use(
    function (response) {
        return response;
    },
    function (error) {
        if (error.response.status === 401) {
            const path = "/sign-in?then=" + error.config.url;
            router.push(path);
        } else {
            return Promise.reject(error);
        }
    }
);

export default $axios;
