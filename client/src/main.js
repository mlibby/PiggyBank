import axios from "axios";
import Vue from "vue";
import VueFlashMessage from "vue-flash-message";

import App from "@/App.vue";
import router from "@/router";
import titleMixin from "@/mixins/titleMixin";

Vue.config.productionTip = false;
Vue.mixin(titleMixin);
Vue.use(VueFlashMessage, {
    messageOptions: {
        timeout: 10000,
        pauseOnInteract: true,
    },
});

const vueInstance = new Vue({
    router,
    render: (h) => h(App),
    data: {
        axios: axios.create(),
        signedIn: false,
    },
}).$mount("#app");
