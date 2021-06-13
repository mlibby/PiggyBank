<template>
    <div class="account-delete">
        <h1>Delete Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="onLoad">
            <account-form
                v-bind:account="account"
                v-bind:accounts="accounts"
                v-bind:account-types="accountTypes"
                v-bind:commodities="commodities"
                :onSubmit="deleteAccount"
                >Delete Account</account-form
            >
        </spinner-div>
        <div v-if="errorMessage" class="error">
            <span class="icon icon-warning">
                <span class="sr-only"> Error: </span>
            </span>
            {{ errorMessage }}
        </div>
    </div>
</template>

<script>
  import axios from "axios";
// import $axios from "@/axios.js";
import AccountForm from "@/components/Account/Form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountDelete",
    title: "Delete Account",
    components: { AccountForm, SpinnerDiv },
    data() {
        return {
            errorMessage: null,
        };
    },
    props: ["account", "accounts", "accountTypes", "commodities", "onLoad"],
    mounted() {
        this.$refs.accountFormDiv.load();
    },
    methods: {
        deleteAccount(next) {
            axios
                .delete("/api/account/" + this.account.id)
                .then(() => {
                    next();
                    this.flash(`Account '${this.account.name}' deleted.`, "deleted");
                    this.$router.go(-1);
                })
                .catch((error) => {
                    this.errorMessage = error.message;
                    next();
                });
        },
    },
};
</script>
