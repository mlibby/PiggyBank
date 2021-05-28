<template>
    <ul class="accounts">
        <li class="account" v-for="account in accounts" :key="account.id">
            <a
                class="name"
                v-bind:class="{ placeholder: account.is_placeholder }"
                v-bind:href="viewLink(account)"
            >
                {{ account.name }}</a
            >
            <a
                v-if="account.parent"
                class="btn primary"
                v-bind:href="editLink(account)"
            >
                <span class="icon icon-pencil"></span>
                <span class="sr-only">Edit Account</span>
            </a>
            <a class="btn secondary" v-bind:href="newSubaccountLink(account)">
                <span class="icon icon-plus"></span>
                <span class="sr-only">Add Subaccount</span>
            </a>
            <a
                v-if="account.parent"
                class="btn danger"
                v-bind:href="deleteLink(account)"
            >
                <span class="icon icon-trash"></span>
                <span class="sr-only">Trash - if account.has_subaccounts?</span>
            </a>
            <account-tree
                v-if="account.subaccounts"
                v-bind:accounts="account.subaccounts"
            >
            </account-tree>
        </li>
    </ul>
</template>

<script>
export default {
    name: "AccountTree",
    props: ["accounts"],
    methods: {
        viewLink(account) {
            return "/account/" + account.id;
        },
        editLink(account) {
            return "/account/" + account.id + "?edit";
        },
        newSubaccountLink(account) {
            return "/account/?new&parent_id=" + account.id;
        },
        deleteLink(account_id) {
            return "/account/" + account.id + "?delete";
        },
    },
};
</script>

<style scoped>
a.btn {
    margin-left: 1rem;
}

li {
    margin-bottom: 0.66rem;
    list-style: none;
}

.name {
    font-size: 1.33rem;
}

.placeholder {
    font-style: italic;
}

ul {
    margin-top: 0.66rem;
}
</style>
