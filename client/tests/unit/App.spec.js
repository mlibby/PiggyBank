import { shallowMount } from "@vue/test-utils";
import App from "@/App.vue";

const axios = {
    get() {
        return Promise.resolve({data: "mock"});
    },
    interceptors: {
        response: {
            use() {}
        }
    }
};

describe("App.vue", () => {
    it("does this", () => {
        const wrapper = shallowMount(App, {
            stubs: ["flash-message", "router-link", "router-view", "$root.axios"],
            mocks: {
                axios,
            },
            propsData: {},
        });

        expect(true).toBe(true);
    });
});
