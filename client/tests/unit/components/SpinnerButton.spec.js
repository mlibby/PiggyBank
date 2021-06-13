import { shallowMount } from "@vue/test-utils";
import SpinnerButton from "@/components/SpinnerButton.vue";

describe("SpinnerButton.vue", () => {
    it("does this", () => {
        const wrapper = shallowMount(SpinnerButton, {
            stubs: ["router-link", "router-view"],
            propsData: {
                onClick: (() => {}),
                onLoad: (() => {}),
            },
        });

        expect(true).toBe(true);
    });
});
