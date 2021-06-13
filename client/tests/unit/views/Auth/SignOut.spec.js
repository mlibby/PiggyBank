import { mount } from "@vue/test-utils";
import SignOut from "@/views/Auth/SignOut.vue";

describe("SignOut.vue", () => {
    it("does this", () => {
        const wrapper = mount(SignOut, {
            stubs: ["router-link", "router-view"],
            propsData: { },
        });

        expect(true).toBe(true);
    });
});
