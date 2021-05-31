import AccountIndex from "../views/Account/Index.vue";
import Account from "../views/Account.vue";
import AccountView from "../views/Account/View.vue";
import AccountNew from "../views/Account/New.vue";
import AccountEdit from "../views/Account/Edit.vue";
import AccountDelete from "../views/Account/Delete.vue";

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
                name: "viewAccount",
                path: "",
                component: AccountView,
            },
            {
                name: "newAccount",
                path: "new",
                component: AccountNew,
            },
            {
                name: "editAccount",
                path: "edit",
                component: AccountEdit,
            },
            {
                name: "deleteAccount",
                path: "delete",
                component: AccountDelete,
            },
        ],
    },
];

export default accountRoutes;
