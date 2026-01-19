# ManagePantry ドキュメント
## 要件
### 目的
食材の在庫を見える化したり、賞味期限切れを防ぎたい！！（ほんだし3つ買ったり、めんつゆ腐らせたりしないように！）

## 機能
|機能|内容|優先度|
|--|--|--|
|在庫管理|食材の名前、数量、賞味期限、カテゴリーの登録、編集、削除|必須|
|期限アラート|賞味期限が３日以内の食材をハイライト|必須|
|在庫のログ|在庫の増減（消費・購入・破棄などなど）を履歴として記録|必須|
|カテゴリー分類|冷蔵、冷凍、常温などのカテゴリーによる分類|必須|
|ユーザー認証|ユーザーごとに在庫を管理|時間的にできたら|

## データベース設計
在庫管理用の設計（ユーザー紐付けもできたらしたい）

```mermaid
erDiagram
    CATEGORY ||--o{ ITEM :""
    ITEM ||--o{ INVENTORY_LOG :""

    CATEGORY {
        bigint id PK
        string name "カテゴリー名（冷蔵・冷凍・常温など）"
    }

    ITEM {
        bigint id PK
        string name "食材名"
        decimal quantity "現在の在庫量"
        string unit "単位（個・g・mlなど）"
        date expiration_date "賞味期限"
        bigint category_id FK
    }

    INVENTORY_LOG {
        bigint id PK
        bigint item_id FK
        decimal change_amount "在庫変動量（+購入 / -消費・廃棄）"
        integer reason "理由（0:購入, 1:消費, 2:廃棄）"
        datetime created_at
    }
```

## クラス設計