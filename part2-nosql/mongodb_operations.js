// mongodb_operations.js
// FlexiMart NoSQL Operations using MongoDB

const { MongoClient } = require("mongodb");
const fs = require("fs");

// ---------------- CONFIG ----------------
const uri = "mongodb://localhost:27017";
const dbName = "fleximart_nosql";
const collectionName = "products";

// ---------------- MAIN FUNCTION ----------------
async function runMongoOperations() {
  const client = new MongoClient(uri);

  try {
    await client.connect();
    console.log("✅ Connected to MongoDB");

    const db = client.db(dbName);
    const collection = db.collection(collectionName);

    // ---------------- LOAD JSON CATALOG ----------------
    const productsData = JSON.parse(
      fs.readFileSync("products_catalog.json", "utf-8")
    );

    // Clear collection before insert (safe for demo)
    await collection.deleteMany({});
    console.log("🧹 Existing products cleared");

    // Insert products
    await collection.insertMany(productsData);
    console.log("📦 Product catalog inserted");

    // ---------------- READ OPERATIONS ----------------

    // 1. Fetch all electronics products
    const electronics = await collection
      .find({ "category.main": "Electronics" })
      .toArray();
    console.log("\n📌 Electronics Products:");
    console.log(electronics);

    // 2. Fetch products with price < 1000
    const affordableProducts = await collection
      .find({ price: { $lt: 1000 } })
      .toArray();
    console.log("\n💰 Affordable Products (<1000):");
    console.log(affordableProducts);

    // ---------------- UPDATE OPERATION ----------------

    // Reduce stock for a specific variant
    const updateResult = await collection.updateOne(
      { "variants.variant_id": "P001-BLK" },
      { $inc: { "variants.$.stock": -5 } }
    );
    console.log(
      `\n🔄 Stock updated for variant P001-BLK (Matched: ${updateResult.matchedCount})`
    );

    // ---------------- AGGREGATION ----------------

    // Calculate total stock per product
    const stockAggregation = await collection.aggregate([
      { $unwind: "$variants" },
      {
        $group: {
          _id: "$product_name",
          total_stock: { $sum: "$variants.stock" }
        }
      }
    ]).toArray();

    console.log("\n📊 Total Stock Per Product:");
    console.log(stockAggregation);

    // ---------------- DELETE OPERATION ----------------

    // Delete discontinued product
    const deleteResult = await collection.deleteOne({ status: "Discontinued" });
    console.log(
      `\n🗑️ Discontinued products deleted: ${deleteResult.deletedCount}`
    );

  } catch (error) {
    console.error("❌ MongoDB Error:", error);
  } finally {
    await client.close();
    console.log("\n🔒 MongoDB connection closed");
  }
}

// ---------------- EXECUTE ----------------
runMongoOperations();
