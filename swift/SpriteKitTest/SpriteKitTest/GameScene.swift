//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Sunghee Lee on 27/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var groundTileMapNode:SKTileMapNode = SKTileMapNode()
    var objectTileMap:SKTileMapNode!
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    func setupObjects() {
        let columns = 24
        let rows = 24
        let size = CGSize(width: 30, height: 30)
        
        guard let tileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        objectTileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: size)
        
        addChild(objectTileMap)
        
        let tileGroups = tileSet.tileGroups
        
        guard let decorationTile = tileGroups.first(where: {$0.name == "Decoration"}) else {
            fatalError("No Decoration tile definintion found")
        }
        
        guard let flowerTile = tileGroups.first(where: {$0.name == "Gas Can"}) else {
            fatalError("No Flower tile definition found")
        }
        
        let numberOfObjects = 64
        
        for i in 1...numberOfObjects {
            
            let column = i
            let row = i
            
//            let column = Int(arc4random_uniform(UInt32(columns)))
//            let row = Int(arc4random_uniform(UInt32(rows)))
            
            let groundTile = groundTileMapNode.tileDefinition(atColumn: columns, row: rows)
            
            let tile = groundTile == nil ? flowerTile : decorationTile
            
            objectTileMap.setTileGroup(tile, forColumn: column, row: row)
        }
    }
    
    override func didMove(to view: SKView) {
        
        for node in self.children {
            if (node.name == "GroundTiles") {
                groundTileMapNode = node as! SKTileMapNode
            }
        }
        
        print(groundTileMapNode)
        print(groundTileMapNode.numberOfColumns)
        print(groundTileMapNode.numberOfRows)
        print(groundTileMapNode.tileDefinition(atColumn: 20, row: 16))
        
        let someTile = groundTileMapNode.tileDefinition(atColumn: 20, row: 16)
        
        print(someTile?.textures)
        
        for col in 0 ..< groundTileMapNode.numberOfColumns {
            for row in 0 ..< groundTileMapNode.numberOfRows {
                
                let tileDefinition = groundTileMapNode.tileDefinition(atColumn: col, row: row)
                if(tileDefinition == nil) {
//                    print("no tile here")
                } else {
                    print("tile here")
                    
                    let tileBoolData = tileDefinition?.userData?["isCenter"] as? Bool
                    
                    if(tileBoolData == true) {
                        print("found a center tile")
                    }
                }
                
                
            }
        }
        
        setupObjects()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        let column = groundTileMapNode.tileColumnIndex(fromPosition: pos)
        let row = groundTileMapNode.tileRowIndex(fromPosition: pos)
        
        if let tile:SKTileDefinition = groundTileMapNode.tileDefinition(atColumn: column, row: row) {
            
            if let tileBoolData = tile.userData?.value(forKey: "isCenter") as? Bool {
                if (tileBoolData == true) {
                    print("touched a center rock")
                }
            } else {
                print("touched a spot with no tile")
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
