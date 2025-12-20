package service;

import dao.ScheduleCollectionDAO;
import model.ScheduleCollection;

import java.util.List;

/**
 * Service layer for schedule collection business logic
 */
public class ScheduleCollectionService {
    private final ScheduleCollectionDAO collectionDAO;

    public ScheduleCollectionService() {
        this.collectionDAO = new ScheduleCollectionDAO();
    }

    /**
     * Get all collections for a user
     */
    public List<ScheduleCollection> getUserCollections(int userId) {
        return collectionDAO.getAllByUserId(userId);
    }

    /**
     * Get collection by ID
     */
    public ScheduleCollection getCollectionById(int collectionId) {
        return collectionDAO.getById(collectionId);
    }

    /**
     * Create a new collection
     */
    public int createCollection(int userId, String collectionName) throws Exception {
        // Validate collection name
        if (collectionName == null || collectionName.trim().isEmpty()) {
            return -1;
        }

        if (collectionName.length() > 100) {
            return -1;
        }

        ScheduleCollection collection = new ScheduleCollection(userId, collectionName.trim());
        return collectionDAO.insert(collection);
    }

    /**
     * Rename a collection
     */
    public boolean renameCollection(int collectionId, String newName) {
        // Validate new name
        if (newName == null || newName.trim().isEmpty()) {
            return false;
        }

        if (newName.length() > 100) {
            return false;
        }

        ScheduleCollection collection = collectionDAO.getById(collectionId);
        if (collection == null) {
            return false;
        }

        collection.setCollectionName(newName.trim());
        return collectionDAO.update(collection);
    }

    /**
     * Delete a collection
     * Prevents deletion if it's the user's only collection
     */
    public boolean deleteCollection(int collectionId, int userId) {
        return collectionDAO.delete(collectionId);
    }

    /**
     * Count collections for a user
     */
    public int countCollections(int userId) {
        return collectionDAO.countByUserId(userId);
    }
}