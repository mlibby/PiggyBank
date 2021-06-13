import { mount } from "@vue/test-utils";
import AccountView from "@/views/Account/View.vue";

describe("AccountView.vue", () => {
    it("does this", () => {
        const wrapper = mount(AccountView, {
            stubs: ["router-link", "router-view"],
            propsData: {
                onLoad: (() => {}),
            },
        });

        expect(true).toBe(true);
    });
});
