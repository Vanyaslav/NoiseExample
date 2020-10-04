//
//  WhiteNoiseGenerator.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation

class KernelAudioUnit: AUAudioUnit {
    // MARK: - Private
    private let _kernel: AudioUnitSampleKernel = AudioUnitSampleKernel()
    
    private var _outputBusArray: AUAudioUnitBusArray!
    private var _internalRenderBlock: AUInternalRenderBlock!
    
    // MARK: - Override
    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions) throws {
        let kernel = self._kernel
        
        self._internalRenderBlock = { (actionFlags,
                                       timeStamp,
                                       frameCount,
                                       outputBusNumber,
                                       outputData,
                                       renderEvent,
                                       pullInputBlock) in
            
            guard let buffer = kernel.buffer else {
                return noErr
            }
            
            buffer.frameLength = frameCount
            
            if let renderBlock = kernel.renderBlock {
                renderBlock(buffer)
            }
            
            let out_abl = UnsafeMutableAudioBufferListPointer(outputData)
            let in_abl = UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList)
            
            for i in 0..<out_abl.count {
                let out_data = out_abl[i].mData
                let in_data = in_abl[i].mData
                
                if out_data == nil {
                    out_abl[i].mData = in_data
                } else if out_data != in_data {
                    memcpy(out_data, in_data, Int(out_abl[i].mDataByteSize))
                }
            }
            
            return noErr
        }
        
        do {
            try super.init(componentDescription: componentDescription, options: options)
            guard let format = WhiteNoiseGenerator.audioFormat else {
                abort()
            }
            let bus = try AUAudioUnitBus(format: format)
            self._outputBusArray = AUAudioUnitBusArray(audioUnit: self,
                                                       busType: AUAudioUnitBusType.output,
                                                       busses: [bus])
        } catch {
            throw error
        }
    }
    
    override var outputBusses : AUAudioUnitBusArray {
        return self._outputBusArray
    }
    
    override var internalRenderBlock: AUInternalRenderBlock {
        return self._internalRenderBlock
    }
    
    override func shouldChange(to format: AVAudioFormat,
                               for bus: AUAudioUnitBus) -> Bool {
        return true
    }
    
    override func allocateRenderResources() throws {
        do {
            try super.allocateRenderResources()
        } catch {
            throw error
        }
        //
        let bus = self.outputBusses[0]
        _kernel.buffer = AVAudioPCMBuffer(pcmFormat: bus.format,
                                          frameCapacity: self.maximumFramesToRender)
    }
    
    override func deallocateRenderResources() {
        _kernel.buffer = nil
    }
    
    // MARK: - Accessor
    var kernelRenderBlock: KernelRenderBlock? {
        get {
            return _kernel.renderBlock
        }
        set {
            _kernel.renderBlock = newValue
        }
    }
}
