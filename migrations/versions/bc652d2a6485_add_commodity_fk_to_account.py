"""add Commodity FK to Account

Revision ID: bc652d2a6485
Revises: 21dc81614120
Create Date: 2021-06-04 22:13:32.974302

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "bc652d2a6485"
down_revision = "21dc81614120"
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table("account") as batch_op:
        batch_op.create_foreign_key(
            "fk_account_commodity",
            "commodity",
            ["commodity_id"],
            ["id"],
        )


def downgrade():
    with op.batch_alter_table("account") as batch_op:
        batch_op.drop_constraint(
            "fk_account_commodity",
            type_="foreignkey",
        )
