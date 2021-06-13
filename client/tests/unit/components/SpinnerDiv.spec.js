import { shallowMount } from "@vue/test-utils";
import SpinnerDiv from "@/components/SpinnerDiv.vue";

describe("SpinnerDiv.vue", () => {
    it("does this", () => {
        const wrapper = shallowMount(SpinnerDiv, {
            stubs: ["router-link", "router-view"],
            propsData: {
                onLoad: (() => {}),
            },
        });

        expect(true).toBe(true);
    });
});

