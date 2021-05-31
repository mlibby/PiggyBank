<template>
    <div class="account-edit">
        <h1>Edit Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="onLoad">
            <account-form
                v-bind:account="account"
                v-bind:accounts="accounts"
                v-bind:account-types="accountTypes"
            ></account-form>
        </spinner-div>
    </div>
</template>

<script>
import AccountForm from "@/components/account/form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountEdit",
    title: "Edit Account",
    components: { AccountForm, SpinnerDiv },
    props: ["account", "accounts", "accountTypes", "onLoad"],
    methods: {
        load(next, error) {
            this.$refs.accountFormDiv.load(next, error);
        },
    },
};
</script>
