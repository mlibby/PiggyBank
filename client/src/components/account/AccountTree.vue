<template>
    <ul class="accounts">
        <li class="account" v-for="account in accounts" :key="account.id">
            <router-link
                class="name"
                v-bind:class="{ placeholder: account.is_placeholder }"
                to="{ name: 'view_account', params: { id: account.id } }"
            >
                {{ account.name }}
            </router-link>
            <router-link
                v-if="account.parent_id"
                class="btn primary"
                :to="{ name: 'edit_account', params: { id: account.id } }"
            >
                <span class="icon icon-pencil"></span>
                <span class="sr-only">Edit Account</span>
            </router-link>
            <router-link
                class="btn secondary"
                :to="{ name: 'new_account', params: { id: account.id } }"
            >
                <span class="icon icon-plus"></span>
                <span class="sr-only">Add Subaccount</span>
            </router-link>
            <router-link
                v-if="account.parent_id"
                class="btn danger"
                :to="{ name: 'delete_account', params: { id: account.id } }"
            >
                <span class="icon icon-trash"></span>
                <span class="sr-only">Trash - if account.has_subaccounts?</span>
            </router-link>
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
};
</script>

<style scoped>
li {
    margin-bottom: 0.66rem;
    list-style: none;
}

.name {
    font-size: 1.33rem;
    margin-right: 0.66rem;
}

.placeholder {
    font-style: italic;
}

ul {
    margin-top: 0.66rem;
}
</style>
