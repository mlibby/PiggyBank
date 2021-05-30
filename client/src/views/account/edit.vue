<template>
    <main>
        <h1>Edit Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="fetchAccount">
            <account-form
                v-bind:account="account"
                v-bind:accounts="accounts"
                v-bind:account-types="accountTypes"
            ></account-form>
        </spinner-div>
    </main>
</template>

<script>
import axios from "axios";
import AccountForm from "@/components/account/form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountEdit",
    title: "Edit Account",
    components: { AccountForm, SpinnerDiv },
    data() {
        return {
            loading: true,
            account: null,
            accounts: [],
            accountTypes: [],
            error: null,
        };
    },
    mounted() {
        this.$refs.accountFormDiv.load();
    },
    methods: {
        async fetchAccount(next, error) {
            const [accountsResponse, accountTypesResponse, accountReponse] =
                await Promise.all([
                    axios.get("/api/account/"),
                    axios.get("/api/account/types"),
                    axios.get("/api/account/" + this.$route.params.id),
                ]).catch((e) => {
                    error(e);
                });

            this.account = accountReponse.data;
            this.accounts = accountsResponse.data;
            this.accounts.sort((first, second) => {
                return first.full_name.localeCompare(second.full_name);
            });
            const thisAccountIndex = this.accounts.findIndex((account) => {
                account.id == this.account.id;
            });
            this.accounts.splice(thisAccountIndex, 1);
            this.accountTypes = accountTypesResponse.data;

            next();
        },
    },
};
</script>
