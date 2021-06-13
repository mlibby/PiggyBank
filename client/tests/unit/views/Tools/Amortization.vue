import { shallowMount } from "@vue/test-utils";
import Amortization from "@/views/Tools/Amortization.vue";

describe("Amortization.vue", () => {
    it("does this", () => {
        const wrapper = shallowMount(Amortization, {
            stubs: ["router-link", "router-view"],
            propsData: { },
        });

        expect(true).toBe(true);
    });
});
