<template>
    <div class="account-edit">
        <h1>Edit Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="onLoad">
            <account-form
                v-bind:account="account"
                v-bind:accounts="accounts"
                v-bind:account-types="accountTypes"
                v-bind:commodities="commodities"
                :onSubmit="saveAccount"
            >
                Save Account
            </account-form>
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
import $axios from "@/axios.js";
import AccountForm from "@/components/Account/Form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountEdit",
    title: "Edit Account",
    components: { AccountForm, SpinnerDiv },
    props: ["account", "accounts", "accountTypes", "commodities", "onLoad"],
    data() {
        return {
            errorMessage: null,
        };
    },
    mounted() {
        this.$refs.accountFormDiv.load();
    },
    methods: {
        saveAccount(next) {
            const data = {
                name: this.account.name,
                account_type: this.account.account_type,
                is_placeholder: this.account.is_placeholder,
                commodity_id: this.account.commodity_id,
                parent_id: this.account.parent_id,
            };
            $axios
                .post("/api/account/" + this.account.id, data)
                .then(() => {
                    next();
                    this.flash(`Account '${this.account.name}' saved.`, "saved");
                    this.$router.go(-1);
                })
                .catch((error) => {
                    this.errorMessage = error.message;
                });
        },
    },
};
</script>
