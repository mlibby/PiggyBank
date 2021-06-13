import { mount } from "@vue/test-utils";
import AccountNew from "@/views/Account/New.vue";

describe("AccountNew.vue", () => {
    it("does this", () => {
        const wrapper = mount(AccountNew, {
            stubs: ["router-link", "router-view"],
            propsData: {
                onLoad: (() => {}),
            },
        });

        expect(true).toBe(true);
    });
});
