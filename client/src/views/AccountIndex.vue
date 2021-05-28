<template>
    <main>
        <h1>Chart of Accounts</h1>
        <p>
            This is your
            <a href="https://en.wikipedia.org/wiki/Chart_of_accounts">
                Chart of Accounts
            </a>
        </p>
        <p>
            Click
            <span class="icon icon-plus">
                <span class="sr-only">add subaccount button</span>
            </span>
            to add a subaccount,
            <span class="icon icon-pencil">
                <span class="sr-only">edit account button</span>
            </span>
            to edit an account,
            <span class="icon icon-trash">
                <span class="sr-only">delete account button</span>
            </span>
            to delete an account.
        </p>

        <div v-if="loading">
            <img src="../assets/spin_primary.svg" />
        </div>
        <div v-if="error" class="error">
            <span class="icon icon-warning">
                <span class="sr-only"> Error: </span>
            </span>
            {{ error }}
        </div>

        <account-tree v-if="accounts" v-bind:accounts="accounts"> </account-tree>

        <p>
            <em>Assets</em>, <em>Liabilities</em>, <em>Income</em>, <em>Expense</em>,
            and <em>Equity</em> are required accounts and may not be edited or deleted.
        </p>
    </main>
</template>

<script>
import axios from "axios";
import AccountTree from "@/components/account/AccountTree.vue";

export default {
    name: "AccountIndex",
    title: "Accounts",
    components: { AccountTree },
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
