import { mount } from "@vue/test-utils";
import SignIn from "@/views/Auth/SignIn.vue";

describe("SignIn.vue", () => {
    it("does this", () => {
        const wrapper = mount(SignIn, {
            stubs: ["router-link", "router-view"],
            propsData: { },
        });

        expect(true).toBe(true);
    });
});
