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

        <spinner-div ref="accountTreeSpinner" :onLoad="fetchAccounts">
            <account-tree v-if="accounts" v-bind:accounts="accounts"> </account-tree>
        </spinner-div>
        <p>
            <em>Assets</em>, <em>Liabilities</em>, <em>Income</em>, <em>Expense</em>,
            and <em>Equity</em> are required accounts and may not be edited or deleted.
        </p>
    </main>
</template>

<script>
import axios from "axios";
import AccountTree from "@/components/Account/Tree.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountIndex",
    title: "Accounts",
    components: { AccountTree, SpinnerDiv },
    data() {
        return {
            accounts: null,
        };
    },
    mounted() {
        this.$refs.accountTreeSpinner.load();
    },
    methods: {
        fetchAccounts(next, error) {
            axios
                .get("/api/account/tree")
                .then((response) => {
                    this.accounts = response.data;
                    next();
                })
                .catch((e) => {
                    error(e);
                });
        },
    },
};
</script>
