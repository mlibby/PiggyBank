import { mount } from "@vue/test-utils";
import AccountEdit from "@/views/Account/Edit.vue";

describe("AccountEdit.vue", () => {
    it("does this", () => {
        const wrapper = mount(AccountEdit, {
            stubs: ["router-link", "router-view"],
            propsData: {
                onLoad: (() => {}),
            },
        });

        expect(true).toBe(true);
    });
});
