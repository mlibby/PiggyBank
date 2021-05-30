import AccountIndex from "../views/account/index.vue";
import Account from "../views/account.vue";
import AccountView from "../views/account/view.vue";
import AccountNew from "../views/account/new.vue";
import AccountEdit from "../views/account/edit.vue";
import AccountDelete from "../views/account/delete.vue";

const accountRoutes = [
    {
        path: "/accounts",
        component: AccountIndex,
    },
    {
        path: "/account/:id",
        component: Account,
        children: [
            {
                name: "view_account",
                path: "",
                component: AccountView,
            },
            {
                name: "new_account",
                path: "new",
                component: AccountNew,
            },
            {
                name: "edit_account",
                path: "edit",
                component: AccountEdit,
            },
            {
                name: "delete_account",
                path: "delete",
                component: AccountDelete,
            },
        ],
    },
];

export default accountRoutes;
