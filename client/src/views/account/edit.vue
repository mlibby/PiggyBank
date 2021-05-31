<template>
    <div class="account-edit">
        <h1>Edit Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="onLoad">
            <account-form
                v-bind:account="account"
                v-bind:accounts="accounts"
                v-bind:account-types="accountTypes"
                v-bind:commodities="commodities"
            ></account-form>
        </spinner-div>
    </div>
</template>

<script>
import AccountForm from "@/components/Account/Form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountEdit",
    title: "Edit Account",
    components: { AccountForm, SpinnerDiv },
    props: ["account", "accounts", "accountTypes", "commodities", "onLoad"],
    methods: {
        load(next, error) {
            this.$refs.accountFormDiv.load(next, error);
        },
    },
};
</script>
