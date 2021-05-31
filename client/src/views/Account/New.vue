<template>
    <div class="account-edit">
        <h1>New Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="onLoad">
            <account-form
                v-bind:account="account"
                v-bind:accounts="accounts"
                v-bind:account-types="accountTypes"
                v-bind:commodities="commodities"
                :onSubmit="saveAccount"
            ></account-form>
        </spinner-div>
    </div>
</template>

<script>
import axios from "axios";
import AccountForm from "@/components/Account/Form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountNew",
    title: "New Account",
    components: { AccountForm, SpinnerDiv },
    props: ["account", "accounts", "accountTypes", "commodities", "onLoad"],
    mounted() {
        this.$refs.accountFormDiv.load();
    },
    methods: {
        saveAccount(next) {
            const data = {
                name: this.account.name,
                account_type: this.account.account_type,
                is_placeholder: this.account.is_placeholder,
                commodity_id: this.account.commodity_id,
                parent_id: this.account.parent_id,
            };
            axios.put("/api/account/", data).then(() => {
                next();
                this.$router.go(-1);
            });
        },
    },
};
</script>
