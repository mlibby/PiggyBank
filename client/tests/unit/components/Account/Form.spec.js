import { mount } from "@vue/test-utils";
import AccountForm from "@/components/Account/Form.vue";

describe("AccountForm.vue", () => {
    it("does this", () => {
        const wrapper = mount(AccountForm, {
            stubs: ["router-link", "router-view"],
            propsData: {
                account: {
                    id: 22,
                    name: "Test Account",
                    account_type: "Asset",
                    commodity_id: 1,
                    parent_id: 2,
                },
                accounts: [],
                accountTypes: [],
                commodities: [],
                onSubmit() {},
            },
        });

        expect(true).toBe(true);
    });
});

