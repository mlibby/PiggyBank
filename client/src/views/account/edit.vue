<template>
    <main>
        <h1>Edit Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="loadAccount">
            <account-form
                v-bind:account="account"
                v-bind:accounts="accounts"
                v-bind:account-types="accountTypes"
            ></account-form>
        </spinner-div>
    </main>
</template>

<script>
import AccountForm from "@/components/account/form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountEdit",
    title: "Edit Account",
    components: { AccountForm, SpinnerDiv },
    props: ["account", "accounts", "accountTypes"],
    methods: {
        loadAccount(next, error) {
            this.$refs.accountFormDiv.load(next, error);
        },
    },
};
</script>
