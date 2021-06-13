import { shallowMount } from "@vue/test-utils";
import NavBar from "@/components/NavBar.vue";

describe("NavBar.vue", () => {
    it("shows 'sign in' link when the user is not signed in", () => {
        const wrapper = shallowMount(NavBar, {
            stubs: ['router-link', 'router-view'],
            propsData: { signedIn: false },
        });

        const signInLink = wrapper.find("section.right");
        expect(signInLink.text()).toBe("Sign In");
    });
});
