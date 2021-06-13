import { mount } from "@vue/test-utils";
import AccountDelete from "@/views/Account/Delete.vue";

describe("AccountDelete.vue", () => {
    it("does this", () => {
        const wrapper = mount(AccountDelete, {
            stubs: ["router-link", "router-view"],
            propsData: {
                onLoad: (() => {}),
            },
        });

        expect(true).toBe(true);
    });
});
