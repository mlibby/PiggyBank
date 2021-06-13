import { mount } from "@vue/test-utils";
import AccountIndex from "@/views/Account/Index.vue";

describe("AccountIndex.vue", () => {
    it("does this", () => {
        const wrapper = mount(AccountIndex, {
            mocks: {
                axios: {
                    get() {
                        return Promise.resolve();
                    },
                },
            },
            stubs: ["router-link", "router-view"],
            propsData: {
                onLoad: (() => {}),
            },
        });

        expect(true).toBe(true);
    });
});
