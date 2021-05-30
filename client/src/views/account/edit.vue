<template>
    <main>
        <h1>Edit Account</h1>
        <account-form v-bind:account="account"></account-form>
    </main>
</template>

<script>
import axios from "axios";
import AccountForm from "@/components/account/form.vue";

export default {
    name: "AccountEdit",
    title: "Edit Account",
    components: { AccountForm },
    data() {
        return {
            loading: true,
            accounts: null,
            error: null,
        };
    },
    created() {
        this.fetchAccounts();
    },
    methods: {
        fetchAccounts() {
            axios
                .get("/api/account")
                .then((response) => {
                    this.loading = false;
                    this.accounts = response.data;
                })
                .catch((error) => {
                    this.loading = false;
                    this.error =
                        error.response && error.response.data
                            ? error.response.data
                            : error.message;
                });
        },
    },
};
</script>
